import { cn } from "@/lib/style";
import { Loader } from "lucide-react";

export const Page = ({
	children,
	className,
}: { children: React.ReactNode; className?: string }) => {
	return (
		<div className={cn("h-full flex flex-col", className)}>{children}</div>
	);
};

export const PageHeader = ({
	children,
	className,
}: { children: React.ReactNode; className?: string }) => {
	return (
		<div
			className={cn(
				"p-4 border-b flex-none flex gap-3 items-center justify-between",
				className,
			)}
		>
			{children}
		</div>
	);
};

export const PageTitle = ({
	title,
	className,
}: { title: string; className?: string }) => {
	return <h2 className={cn("text-xl font-bold", className)}>{title}</h2>;
};

export const PageSection = ({
	id,
	children,
	className,
}: { id: string; children: React.ReactNode; className?: string }) => {
	return (
		<section
			id={id}
			className={cn("h-full p-4 grow flex flex-col gap-3", className)}
		>
			{children}
		</section>
	);
};

export const PageLoading = ({ className }: { className?: string }) => {
	return (
		<div className={cn("flex items-center justify-center", className)}>
			<Loader className={"h-8 w-8 animate-spin"} />
		</div>
	);
};

export const PageFooter = ({
	children,
	className,
}: { children: React.ReactNode; className?: string }) => {
	return (
		<div className={cn("p-4 border-t flex-none flex gap-3", className)}>
			{children}
		</div>
	);
};
