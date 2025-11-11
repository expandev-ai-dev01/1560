import { z } from 'zod';

export const zString = z.string().min(1);
export const zNullableString = (maxLength?: number) => {
  let schema = z.string();
  if (maxLength) {
    schema = schema.max(maxLength);
  }
  return schema.nullable();
};

export const zName = z.string().min(1).max(200);
export const zNullableDescription = z.string().max(500).nullable();

export const zFK = z.number().int().positive();
export const zNullableFK = z.number().int().positive().nullable();

export const zBit = z.union([z.literal(0), z.literal(1)]);

export const zDateString = z
  .string()
  .refine((val) => !isNaN(Date.parse(val)), { message: 'Invalid date format' });

export const zEmail = z.string().email();

export const zNumeric = (precision: number = 15, scale: number = 2) =>
  z.number().refine(
    (val) => {
      const strVal = val.toString();
      const parts = strVal.split('.');
      const integerPart = parts[0].replace('-', '');
      const decimalPart = parts[1] || '';
      return integerPart.length <= precision - scale && decimalPart.length <= scale;
    },
    { message: `Number must fit NUMERIC(${precision},${scale})` }
  );
