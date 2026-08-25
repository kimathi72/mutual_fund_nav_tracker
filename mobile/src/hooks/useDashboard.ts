
import { useQuery } from '@tanstack/react-query';

import { getDashboard } from '../api/dashboard';

export const useDashboard = () => {
  return useQuery({
    queryKey: ['dashboard'],
    queryFn: getDashboard,
    staleTime: 60_000,
  });
};
