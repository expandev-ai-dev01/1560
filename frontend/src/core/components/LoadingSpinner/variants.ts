import { clsx } from 'clsx';

export interface LoadingSpinnerVariantProps {
  size?: 'sm' | 'md' | 'lg';
  color?: 'primary' | 'secondary' | 'white';
}

export function getLoadingSpinnerClassName(props: LoadingSpinnerVariantProps): string {
  const { size = 'md', color = 'primary' } = props;

  return clsx(
    {
      'w-6 h-6': size === 'sm',
      'w-10 h-10': size === 'md',
      'w-16 h-16': size === 'lg',
    },
    {
      'text-blue-600': color === 'primary',
      'text-gray-600': color === 'secondary',
      'text-white': color === 'white',
    }
  );
}
