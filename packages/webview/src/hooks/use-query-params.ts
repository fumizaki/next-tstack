"use client";

import { useCallback, useMemo } from "react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";

type Param = {
	key: string;
	value: string | string[];
};

export function useQueryParams() {
	const pathname = usePathname();
	const router = useRouter();
	const searchParams = useSearchParams();
	const queryParams = useMemo(() => {
		return new URLSearchParams(searchParams?.toString() || "");
	}, [searchParams]);

	const setQueryParams = useCallback(
		(param: Param) => {
			if (!param.value) {
				queryParams.delete(param.key);
				return;
			}
			if (Array.isArray(param.value)) {
				queryParams.delete(param.key);
				param.value.forEach((v) => queryParams.append(param.key, v));
				return;
			}
			queryParams.set(param.key, param.value);
		},
		[queryParams],
	);

	const pushQuery = useCallback(
		(params: Param | Param[]) => {
			if (Array.isArray(params)) {
				params.forEach((param: Param) => {
					setQueryParams(param);
				});
			} else {
				setQueryParams(params);
			}
			router.replace(pathname + "?" + queryParams.toString());
		},
		[pathname, router, queryParams, setQueryParams],
	);

	return {
		queryParams,
		setQueryParams,
		pushQuery,
	};
}
