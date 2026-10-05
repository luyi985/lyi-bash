# Exact compatibility

`implements` proves that a class has at least the generated fields. It does not reject extra public data fields.

## Shared helpers

```ts
type Assert<T extends true> = T;

type IsEqual<A, B> =
  [A] extends [B]
    ? ([B] extends [A] ? true : false)
    : false;

type DataProperties<T> = {
  [K in keyof T as T[K] extends (...args: any[]) => any ? never : K]: T[K];
};
```

For a class:

```ts
type _UserContractExact = Assert<
  IsEqual<DataProperties<User>, GeneratedUser>
>;
```

## Caveats

Review before using exact equality:

- readonly differences;
- optional properties under `exactOptionalPropertyTypes`;
- index signatures;
- getters/setters;
- inherited public properties;
- branded and opaque types;
- private/protected members;
- external package types.

When exact equality is inappropriate, document the one-way compatibility rule and why.

Do not silence failures with `any`, broad casts, or `@ts-ignore`.
