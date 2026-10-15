import assert from 'node:assert/strict';
import test from 'node:test';
import { formatConversion } from '../entry/src/main/ets/feature/ConversionFormatter.ts';

test('formats boundaries without crashing or losing nonzero values', () => {
  assert.equal(formatConversion(1e14), '1e+14');
  assert.equal(formatConversion(-1e13), '-1e+13');
  assert.equal(formatConversion(1e-9), '1e-9');
  assert.equal(formatConversion(-1e-9), '-1e-9');
});

test('keeps ordinary and zero results readable', () => {
  assert.equal(formatConversion(0), '0');
  assert.equal(formatConversion(12.3456789), '12.3456789');
  assert.equal(formatConversion(1 / 3), '0.33333333');
});

test('limits finite output width', () => {
  for (const value of [12345678901234, -12345678901234, 1e-100, -1e308]) {
    assert.ok(formatConversion(value).length <= 14);
  }
});
