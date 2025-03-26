"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Button } from "@/components/ui/button";
import { HeaderThemeRadio } from "./theme-radio";
import { Settings } from "lucide-react";

export type HeaderMenuLink = {
	href: string;
	label: string;
	icon: React.ReactNode;
};

type Props = {
	isAuthenticated?: boolean;
	authenticatedLinks: HeaderMenuLink[];
	unauthenticatedLinks: HeaderMenuLink[];
};

export const HeaderDropdownMenu = ({
	isAuthenticated,
	authenticatedLinks,
	unauthenticatedLinks,
}: Props) => {
	const pathname = usePathname();

	return (
		<DropdownMenu>
			<DropdownMenuTrigger asChild>
				<Button variant="outline" size="icon">
					<Settings className={"w-4 h-4 "} />
				</Button>
			</DropdownMenuTrigger>
			<DropdownMenuContent align="end" className={"flex flex-col gap-2 p-2"}>
				{isAuthenticated &&
					authenticatedLinks.map((link) => (
						<DropdownMenuItem
							key={link.href}
							className={`w-full ${pathname.startsWith(link.href) && "bg-primary text-secondary"}`}
							asChild
						>
							<Link href={link.href}>
								{link.icon}
								{link.label}
							</Link>
						</DropdownMenuItem>
					))}
				{!isAuthenticated &&
					unauthenticatedLinks.map((link) => (
						<DropdownMenuItem
							key={link.href}
							className={`w-full ${pathname.startsWith(link.href) && "bg-primary text-secondary"}`}
							asChild
						>
							<Link href={link.href}>
								{link.icon}
								{link.label}
							</Link>
						</DropdownMenuItem>
					))}
				<HeaderThemeRadio />
			</DropdownMenuContent>
		</DropdownMenu>
	);
};
