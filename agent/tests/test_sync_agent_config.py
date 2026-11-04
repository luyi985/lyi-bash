"""Integration checks using isolated homes; never install into the real home."""

import os
from pathlib import Path
import re
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "sync-agent-config.sh"


class SyncAgentConfigTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="agent-sync-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces & symbols"
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home))
        self.env.pop("AGENTS_HOME", None)

    def run_sync(self, *args, success=True):
        result = subprocess.run(
            ["bash", str(SCRIPT), *args], env=self.env,
            text=True, capture_output=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0)
        return result

    def snapshot(self):
        return {
            path.relative_to(self.home): path.read_bytes()
            for path in self.home.rglob("*") if path.is_file()
        }

    def assert_installed_links(self, dest):
        entrypoints = [
            dest / "AGENTS.md",
            self.home / ".codex/AGENTS.md",
            self.home / ".claude/CLAUDE.md",
            self.home / ".copilot/copilot-instructions.md",
            self.home / ".gemini/GEMINI.md",
            self.home / ".cursor/rules/shared-agent-instructions.mdc",
        ]
        workflow = dest / "workflows/copilot-llm-instruction.md"
        for entrypoint in entrypoints:
            content = entrypoint.read_text()
            self.assertIn(f"(<{workflow}>)", content)
            self.assertIn(f"{dest}/standards/", content)
            self.assertIn(f"{dest}/workflows/sdd.md", content)
            for target in re.findall(r"\]\(<([^>]+)>\)", content):
                self.assertTrue(Path(target.split("#")[0]).is_file(), target)
        self.assertIn(f"(<{dest}/AGENTS.md#copilot-mode>)", workflow.read_text())
        self.assertTrue(entrypoints[-1].read_text().startswith("---\nalwaysApply: true\n---\n"))

    def test_install_links_and_repeat_sync(self):
        self.run_sync()
        self.assert_installed_links(self.home / ".agents")
        before = self.snapshot()
        result = self.run_sync()
        self.assertEqual(before, self.snapshot())
        self.assertNotIn("installed ", result.stdout)
        self.assertNotIn("SKIP", result.stderr)

    def test_custom_destination(self):
        dest = self.home / "custom shared directory"
        self.env["AGENTS_HOME"] = str(dest)
        self.run_sync()
        self.assert_installed_links(dest)

    def test_dry_run_does_not_install(self):
        self.run_sync("--dry-run")
        self.assertEqual({}, self.snapshot())

    def test_skip_force_backup_and_backup_collision(self):
        self.run_sync()
        target = self.home / ".codex/AGENTS.md"
        target.write_text("existing user instructions\n")
        before = self.snapshot()
        result = self.run_sync()
        self.assertIn("SKIP existing file", result.stderr)
        self.assertEqual(before, self.snapshot())
        self.run_sync("--dry-run", "--force")
        self.assertEqual(before, self.snapshot())
        self.run_sync("--force")
        backup = target.with_name(target.name + ".bak")
        self.assertEqual(backup.read_text(), "existing user instructions\n")
        self.assert_installed_links(self.home / ".agents")
        target.write_text("new user edits\n")
        before = self.snapshot()
        result = self.run_sync("--force", success=False)
        self.assertIn("ERROR backup exists", result.stderr)
        self.assertEqual(before, self.snapshot())


if __name__ == "__main__":
    unittest.main()
