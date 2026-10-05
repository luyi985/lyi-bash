# Integration patterns

## Class

```ts
import type { User as GeneratedUser } from "../generated";

export class User implements GeneratedUser {
  public id!: string;
  public name?: string;

  public displayName(): string {
    return this.name ?? this.id;
  }
}
```

Do not alter methods or runtime shape merely to satisfy the contract. Repair the Schema first when the generated contract is wrong.

## Interface

```ts
import type {
  CreateUserRequest as GeneratedCreateUserRequest,
} from "../generated";

type Assert<T extends true> = T;
type Extends<Actual, Expected> =
  [Actual] extends [Expected] ? true : false;

type _DomainSatisfiesGenerated = Assert<
  Extends<CreateUserRequest, GeneratedCreateUserRequest>
>;
```

Use a reverse assertion when exact equivalence is required.

## Type alias

Apply the same compile-time assertion. Do not convert it to a class.

## Enum

Enums do not use `implements`.

First classify the enum as `SAFE_TO_MIGRATE`, `RETAIN_WITH_ASSERTION`, `BLOCKED`, or `NOT_SCHEMA_BACKED`.

For a safe identity string enum:

```ts
import type { Status as GeneratedStatus } from "../generated";

export const Status = {
  Active: "Active",
  Inactive: "Inactive",
} as const satisfies {
  [K in GeneratedStatus]: K;
};

export type Status =
  (typeof Status)[keyof typeof Status];
```

Do not use `Record<GeneratedStatus, GeneratedStatus>` for identity mappings because it allows keys and values to be swapped.

See [enum-integration.md](enum-integration.md) for alias keys, retained enums, exception evidence, numeric enums, and migration safety.

## Imports

Prefer:

```ts
import type { User as GeneratedUser } from "../generated";
```

Avoid:

```ts
import type { SomeHelper } from "../generated/user.schema";
```

Only public root contracts belong in Domain integration.
