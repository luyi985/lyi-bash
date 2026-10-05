# Approved ESLint plugin installation

Use the bundled plugin template exactly:

```text
assets/eslint-plugin-schema-domain-check/
  package.json
  index.cjs
```

Install it into each repository as:

```text
eslint-plugin-schema-domain-check/
  package.json
  index.cjs
```

This is a private local file package, not a registry dependency and not a request to design a new plugin.

## Package registration

Add to the repository root `package.json`:

```json
{
  "devDependencies": {
    "eslint-plugin-schema-domain-check": "file:eslint-plugin-schema-domain-check"
  }
}
```

Run the repository's normal install command to update the lockfile and install the local package.

## Actual exported rule

The bundled `index.cjs` exports:

```text
domain-class-implements-schema-generated-type
```

The full ESLint rule ID is:

```text
schema-domain-check/domain-class-implements-schema-generated-type
```

Do not use the obsolete documentation example:

```text
schema-domain-check/require-implements-generated
```

It is not exported by this plugin.

## Legacy configuration

```json
{
  "plugins": ["schema-domain-check"]
}
```

Recommended dedicated command:

```json
{
  "scripts": {
    "lint:schema-domain-check": "eslint src/**/domain/**/*.ts --quiet --rule schema-domain-check/domain-class-implements-schema-generated-type:error"
  }
}
```

Change only the Domain glob to match the repository.

## Flat configuration

Load the installed local package using the repository's current CommonJS or ESM convention and register it with the key `schema-domain-check`. Enable:

```text
schema-domain-check/domain-class-implements-schema-generated-type: error
```

Do not add a legacy config when the repository already uses flat config.

## What the plugin checks

The supplied rule:

- inspects exported non-abstract classes;
- requires at least one instance field or constructor parameter property;
- skips `Error` subclasses by default;
- collects types imported from module paths matching `/generated/`;
- requires the class to implement a type imported from such a generated module.

## What it does not prove

Use coverage and typechecking for:

- interfaces and type aliases;
- enums and unions;
- exact equality or extra properties;
- semantic correctness of the Schema;
- correct enum/date/runtime behavior;
- indirect export patterns outside the rule's visitor;
- complex multiple-interface implementation cases.

The plugin is a regression guard for missing generated `implements`, not a replacement for coverage auditing or TypeScript compilation.

## Validation

Confirm the package exports the expected rule:

```bash
node -e 'const p=require("./eslint-plugin-schema-domain-check"); if(!p.rules?.["domain-class-implements-schema-generated-type"]) process.exit(1)'
```

Then run:

```text
package-manager install
npm run lint:schema-domain-check
npm run typecheck
npm run build
```

## No-allowlist policy

The rule must not expose or consume an `allowlist` option. Do not add class names to ESLint configuration to silence violations. A configuration such as the following is prohibited:

```json
{
  "schema-domain-check/domain-class-implements-schema-generated-type": [
    "error",
    { "allowlist": ["SomeDomainClass"] }
  ]
}
```

Fix each eligible class so it imports and implements the correct generated contract. If a class is not a JSON-shaped Domain contract, correct the plugin eligibility logic centrally with evidence; do not create per-class bypasses.
