// ESLint flat config for React + TypeScript (ESLint 9+).
// Install:
//   npm i -D eslint @eslint/js typescript-eslint eslint-plugin-react eslint-plugin-react-hooks \
//            eslint-plugin-jsx-a11y globals
// Adjust ignores and file globs to the project.
import js from '@eslint/js';
import { defineConfig } from 'eslint/config';
import tseslint from 'typescript-eslint';
import react from 'eslint-plugin-react';
import reactHooks from 'eslint-plugin-react-hooks';
import jsxA11y from 'eslint-plugin-jsx-a11y';
import globals from 'globals';

export default defineConfig([
  { ignores: ['dist', 'build', 'coverage', '.next', 'node_modules'] },

  js.configs.recommended,
  tseslint.configs.strictTypeChecked,
  tseslint.configs.stylisticTypeChecked,
  {
    languageOptions: {
      parserOptions: { projectService: true, tsconfigRootDir: import.meta.dirname },
      globals: { ...globals.browser },
    },
  },

  // React
  {
    files: ['**/*.{jsx,tsx}'],
    ...react.configs.flat.recommended,
    settings: { react: { version: 'detect' } },
  },
  react.configs.flat['jsx-runtime'],
  {
    plugins: { 'react-hooks': reactHooks },
    rules: {
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'error',
    },
  },
  jsxA11y.flatConfigs.recommended,

  // House rules
  {
    rules: {
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-floating-promises': 'error',
      '@typescript-eslint/no-misused-promises': ['error', { checksVoidReturn: { attributes: false } }],
      '@typescript-eslint/consistent-type-imports': 'error',
      '@typescript-eslint/ban-ts-comment': ['error', { 'ts-expect-error': 'allow-with-description' }],
      '@typescript-eslint/switch-exhaustiveness-check': 'error',
      'react/prop-types': 'off', // types come from TS / JSDoc
      'react/no-array-index-key': 'warn',
      'react/jsx-no-leaked-render': ['error', { validStrategies: ['ternary', 'coerce'] }],
      'react/no-unstable-nested-components': 'error',
      'no-console': ['warn', { allow: ['warn', 'error'] }],
      eqeqeq: ['error', 'smart'],
    },
  },

  // Node / server files
  {
    files: ['server/**', 'api/**', '**/*.server.ts', '*.config.{js,ts}'],
    languageOptions: { globals: { ...globals.node } },
    rules: { 'no-console': 'error' }, // use the structured logger
  },

  // Plain JS files: skip type-aware rules if not covered by tsconfig
  { files: ['**/*.{js,mjs,cjs}'], ...tseslint.configs.disableTypeChecked },
]);
