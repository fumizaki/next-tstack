import { cn } from "@/lib/style";
import { HeaderLogo } from "./logo";
import { HeaderDropdownMenu, type HeaderMenuLink } from "./dropdown-menu";
import { Coins, User2 } from "lucide-react";

export const Header = ({ className }: { className?: string }) => {
	const isAuthenticated = true;

	const buildAuthenticatedLinks = (): HeaderMenuLink[] => {
		return [
			{
				href: "/rich-text-editor",
				label: "RichTextEditor",
				icon: <Coins className="h-4 w-4 mr-2" />,
			},
		];
	};

	const buildUnauthenticatedLinks = (): HeaderMenuLink[] => {
		return [
			{
				href: "/login",
				label: "Login",
				icon: <User2 className="h-4 w-4 mr-2" />,
			},
			{
				href: "/register",
				label: "Register",
				icon: <Coins className="h-4 w-4 mr-2" />,
			},
		];
	};

	return (
		<header
			className={cn(
				"w-full h-20 flex justify-between items-center text-primary bg-slate-100 dark:bg-slate-950 border-b border-slate-300 dark:border-slate-300",
				className,
			)}
		>
			<div className={"flex items-center gap-2 pl-4"}>
				<HeaderLogo />
			</div>
			<div className={"pr-8"}>
				<HeaderDropdownMenu
					isAuthenticated={isAuthenticated}
					authenticatedLinks={buildAuthenticatedLinks()}
					unauthenticatedLinks={buildUnauthenticatedLinks()}
				/>
			</div>
		</header>
	);
};
