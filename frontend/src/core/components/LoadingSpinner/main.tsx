import { getLoadingSpinnerClassName } from './variants';
import type { LoadingSpinnerProps } from './types';

export const LoadingSpinner = ({
  size = 'md',
  color = 'primary',
  fullScreen = false,
}: LoadingSpinnerProps) => {
  const spinnerClass = getLoadingSpinnerClassName({ size, color });
  const containerClass = fullScreen
    ? 'fixed inset-0 flex items-center justify-center bg-white bg-opacity-75 z-50'
    : 'flex items-center justify-center p-4';

  return (
    <div className={containerClass}>
      <div className={spinnerClass}>
        <div className="animate-spin rounded-full border-4 border-current border-t-transparent" />
      </div>
    </div>
  );
};
