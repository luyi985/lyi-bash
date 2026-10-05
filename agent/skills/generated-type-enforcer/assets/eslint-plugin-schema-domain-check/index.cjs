/**
 * Domain DTO classes must `implements` a type imported from the project generated barrel
 * (for this architecture, normally `./generated` or `../generated` inside the Domain package).
 *
 * Skipped: abstract classes, classes with no instance fields, and Error subclasses when configured.
 */

const DEFAULT_GENERATED_IMPORT_PATTERN = /(?:^|\/)generated(?:\/|$)/;

function parseRuleOptions(context) {
  const [options = {}] = context.options;
  const generatedImportPattern =
    typeof options.generatedImportPattern === "string"
      ? new RegExp(options.generatedImportPattern)
      : DEFAULT_GENERATED_IMPORT_PATTERN;
  return {
    generatedImportPattern,
    skipExtendsError: options.skipExtendsError !== false,
  };
}

function isGeneratedModule(source, pattern) {
  if (typeof source !== "string") return false;
  return pattern.test(source.replace(/\\/g, "/"));
}

function addBinding(bindings, name) {
  if (name) bindings.add(name);
}

/** Local type names for symbols imported/re-exported from /generated modules in this file. */
function collectGeneratedTypeBindings(body, pattern) {
  const bindings = new Set();

  for (const stmt of body) {
    if (stmt.type === "ImportDeclaration" && isGeneratedModule(stmt.source?.value, pattern)) {
      for (const spec of stmt.specifiers ?? []) {
        if (spec.type === "ImportSpecifier" || spec.type === "ImportDefaultSpecifier") {
          addBinding(bindings, spec.local?.name);
        }
        if (spec.type === "ImportNamespaceSpecifier") {
          addBinding(bindings, spec.local?.name);
        }
      }
      continue;
    }

    if (
      stmt.type === "ExportNamedDeclaration" &&
      stmt.source &&
      isGeneratedModule(stmt.source.value, pattern)
    ) {
      for (const spec of stmt.specifiers ?? []) {
        if (spec.type === "ExportSpecifier") {
          addBinding(bindings, spec.local?.name ?? spec.exported?.name);
        }
      }
    }
  }

  return bindings;
}

function isExportClass(node) {
  if (node.type === "ExportNamedDeclaration" && node.declaration?.type === "ClassDeclaration") {
    return node.declaration;
  }
  if (node.type === "ClassDeclaration" && node.parent?.type === "ExportNamedDeclaration") {
    return node;
  }
  return null;
}

function hasInstanceFields(classNode) {
  for (const member of classNode.body?.body ?? []) {
    if (member.type === "PropertyDefinition" && !member.static) {
      return true;
    }
    if (member.type === "MethodDefinition" && member.kind === "constructor") {
      for (const param of member.value?.params ?? []) {
        if (param.type === "TSParameterProperty") {
          return true;
        }
        if (param.type === "AssignmentPattern" && param.left?.type === "TSParameterProperty") {
          return true;
        }
      }
    }
  }
  return false;
}

function extendsError(classNode) {
  const superClass = classNode.superClass;
  if (!superClass) return false;
  if (superClass.type === "Identifier" && superClass.name === "Error") return true;
  if (superClass.type === "MemberExpression" && superClass.property?.name === "Error") return true;
  return false;
}

function shouldRequireWireImplements(classNode, { skipExtendsError }) {
  if (!classNode?.id?.name) return false;
  if (classNode.abstract) return false;
  if (skipExtendsError && extendsError(classNode)) return false;
  return hasInstanceFields(classNode);
}

function expressionUsesGeneratedBinding(expr, bindings) {
  if (!expr) return false;
  if (expr.type === "Identifier") {
    return bindings.has(expr.name);
  }
  if (expr.type === "TSQualifiedName") {
    return expressionUsesGeneratedBinding(expr.left, bindings);
  }
  return false;
}

function describeImplementsExpression(expr) {
  if (!expr) return "<unknown>";
  if (expr.type === "Identifier") return expr.name;
  if (expr.type === "TSQualifiedName") {
    const right = expr.right?.type === "Identifier" ? expr.right.name : "";
    return `${describeImplementsExpression(expr.left)}.${right}`;
  }
  return "<expression>";
}

module.exports = {
  rules: {
    "domain-class-implements-schema-generated-type": {
      meta: {
        type: "problem",
        docs: {
          description:
            "Exported domain DTO classes must implement a type imported from a /generated module",
        },
        schema: [
          {
            type: "object",
            properties: {
              generatedImportPattern: {
                type: "string",
                description:
                  "Regex for import source paths counted as generated (default: /(?:^|\\/)generated(?:\\/|$)/)",
              },
              skipExtendsError: {
                type: "boolean",
                description: "Skip classes that extend Error (default: true)",
              },
            },
            additionalProperties: false,
          },
        ],
      },
      create(context) {
        const options = parseRuleOptions(context);
        let generatedBindings = new Set();

        return {
          Program(node) {
            generatedBindings = collectGeneratedTypeBindings(node.body, options.generatedImportPattern);
          },
          ExportNamedDeclaration(node) {
            const classNode = isExportClass(node);
            if (!shouldRequireWireImplements(classNode, options)) return;

            const className = classNode.id.name;
            const implementsList = classNode.implements ?? [];

            if (!implementsList.length) {
              context.report({
                node: classNode.id,
                message: `Exported class "${className}" must implement a type imported from a /generated module (normally the Domain-internal generated barrel).`,
              });
              return;
            }

            for (const impl of implementsList) {
              if (expressionUsesGeneratedBinding(impl.expression, generatedBindings)) {
                continue;
              }
              const typeLabel = describeImplementsExpression(impl.expression);
              context.report({
                node: impl.expression ?? impl,
                message: `Exported class "${className}" must implement a type from /generated; "${typeLabel}" is not imported from a /generated module in this file.`,
              });
            }
          },
        };
      },
    },
  },
};
