"use client";

import { useState, useEffect } from "react";
import { useTheme } from "next-themes";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Label } from "@/components/ui/label";
import { Monitor, Sun, Moon } from "lucide-react";

export const HeaderThemeRadio = () => {
	const [mounted, setMounted] = useState(false);
	const { theme, setTheme } = useTheme();

	useEffect(() => {
		setMounted(true);
	}, []);

	if (!mounted) {
		return null;
	}

	return (
		<RadioGroup
			defaultValue={theme}
			onValueChange={(value: string) => setTheme(value)}
			className="flex bg-secondary p-1 rounded-lg"
		>
			<div className="flex items-center space-x-2">
				<RadioGroupItem value="system" id="system" className="sr-only peer" />
				<Label
					htmlFor="system"
					className="p-2 rounded-md peer-aria-checked:bg-background cursor-pointer"
				>
					<Monitor className="h-4 w-4" />
					<span className="sr-only">System</span>
				</Label>
			</div>
			<div className="flex items-center space-x-2">
				<RadioGroupItem value="light" id="light" className="sr-only peer" />
				<Label
					htmlFor="light"
					className="p-2 rounded-md peer-aria-checked:bg-background cursor-pointer"
				>
					<Sun className="h-4 w-4" />
					<span className="sr-only">Light</span>
				</Label>
			</div>
			<div className="flex items-center space-x-2">
				<RadioGroupItem value="dark" id="dark" className="sr-only peer" />
				<Label
					htmlFor="dark"
					className="p-2 rounded-md peer-aria-checked:bg-background cursor-pointer"
				>
					<Moon className="h-4 w-4" />
					<span className="sr-only">Dark</span>
				</Label>
			</div>
		</RadioGroup>
	);
};
