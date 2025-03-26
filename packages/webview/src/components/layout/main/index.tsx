import { cn } from "@/lib/style";

export const Main = ({
	className,
	children,
}: { className?: string; children: React.ReactNode }) => {
	return (
		<main className={cn("center h-max w-screen mx-auto", className)}>
			{children}
		</main>
	);
};
