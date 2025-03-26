import { cn } from "@/lib/style";

export const Footer = ({ className }: { className?: string }) => {
	return (
		<footer
			className={cn(
				"w-full flex justify-between items-center bg-slate-100 dark:bg-slate-950 border-t border-slate-300 dark:border-slate-300",
				className,
			)}
		>
			<div className={"h-20"} />
		</footer>
	);
};
