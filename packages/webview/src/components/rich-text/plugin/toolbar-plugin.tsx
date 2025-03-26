import {
	useEditor,
	type EditorContextType,
} from "@/components/rich-text/context/editor";
import { Button } from "@/components/ui/button";
import {
	ChevronDown,
	RotateCcw,
	RotateCw,
	Type,
	Heading2,
	Heading3,
	Heading4,
	Heading5,
	Heading6,
	Code,
	Quote,
	List,
	ListOrdered,
	ListChecks,
	Underline,
	Italic,
	Bold,
	Link,
	Strikethrough,
	Subscript,
	Superscript,
	RemoveFormatting,
	Image,
	Plus,
	ALargeSmall,
	PaintBucket,
	Baseline,
} from "lucide-react";
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuItem,
	DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useCallback } from "react";

const UndoRedoContainer = ({ editor }: { editor: EditorContextType }) => {
	return (
		<div className={`flex`}>
			<Button
				variant={"ghost"}
				size={"icon"}
				onClick={editor.undo}
				disabled={!editor.canUndo}
			>
				<RotateCcw className={`h-4 w-4`} />
			</Button>
			<Button
				variant={"ghost"}
				size={"icon"}
				onClick={editor.redo}
				disabled={!editor.canRedo}
			>
				<RotateCw className={`h-4 w-4`} />
			</Button>
		</div>
	);
};

const BlockTypeContainer = ({ editor }: { editor: EditorContextType }) => {
	const renderText = useCallback((children: React.ReactNode) => {
		return <div className="flex items-center gap-1">{children}</div>;
	}, []);

	const renderParagraph = useCallback(() => {
		return renderText(
			<>
				<Type className={"h-4 w-4"} />
				<p>本文テキスト</p>
			</>,
		);
	}, [renderText]);

	const renderHeading2 = useCallback(() => {
		return renderText(
			<>
				<Heading2 className={"h-4 w-4"} />
				<p>見出し2</p>
			</>,
		);
	}, [renderText]);

	const renderHeading3 = useCallback(() => {
		return renderText(
			<>
				<Heading3 className={"h-4 w-4"} />
				<p>見出し3</p>
			</>,
		);
	}, [renderText]);

	const renderHeading4 = useCallback(() => {
		return renderText(
			<>
				<Heading4 className={"h-4 w-4"} />
				<p>見出し4</p>
			</>,
		);
	}, [renderText]);

	const renderHeading5 = useCallback(() => {
		return renderText(
			<>
				<Heading5 className={"h-4 w-4"} />
				<p>見出し5</p>
			</>,
		);
	}, [renderText]);

	const renderHeading6 = useCallback(() => {
		return renderText(
			<>
				<Heading6 className={"h-4 w-4"} />
				<p>見出し6</p>
			</>,
		);
	}, [renderText]);

	const renderQuote = useCallback(() => {
		return renderText(
			<>
				<Quote className={"h-4 w-4"} />
				<p>引用</p>
			</>,
		);
	}, [renderText]);

	const renderList = useCallback(
		(ordered: boolean) => {
			return renderText(
				<>
					{ordered ? (
						<ListOrdered className={"h-4 w-4"} />
					) : (
						<List className={"h-4 w-4"} />
					)}
					<p>{ordered ? "番号付きリスト" : "箇条書きリスト"}</p>
				</>,
			);
		},
		[renderText],
	);

	const renderCheckList = useCallback(() => {
		return renderText(
			<>
				<ListChecks className={"h-4 w-4"} />
				<p>チェックリスト</p>
			</>,
		);
	}, [renderText]);

	return (
		<DropdownMenu>
			<DropdownMenuTrigger asChild>
				<Button variant="ghost" className={`flex gap-1`}>
					{editor.blockType === "paragraph"
						? renderParagraph()
						: editor.blockType === "h2"
							? renderHeading2()
							: editor.blockType === "h3"
								? renderHeading3()
								: editor.blockType === "h4"
									? renderHeading4()
									: editor.blockType === "h5"
										? renderHeading5()
										: editor.blockType === "h6"
											? renderHeading6()
											: editor.blockType === "quote"
												? renderQuote()
												: editor.blockType === "bullet"
													? renderList(false)
													: editor.blockType === "number"
														? renderList(true)
														: editor.blockType === "check"
															? renderCheckList()
															: null}
					<ChevronDown className={`h-4 w-4`} />
				</Button>
			</DropdownMenuTrigger>
			<DropdownMenuContent align="end">
				<DropdownMenuItem onClick={editor.toggleParagraph}>
					{renderParagraph()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={() => editor.toggleHeading("h2")}>
					{renderHeading2()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={() => editor.toggleHeading("h3")}>
					{renderHeading3()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={() => editor.toggleHeading("h4")}>
					{renderHeading4()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={() => editor.toggleHeading("h5")}>
					{renderHeading5()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={() => editor.toggleHeading("h6")}>
					{renderHeading6()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={editor.toggleBulletList}>
					{renderList(false)}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={editor.toggleNumberList}>
					{renderList(true)}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={editor.toggleCheckList}>
					{renderCheckList()}
				</DropdownMenuItem>
				<DropdownMenuItem onClick={editor.toggleQuote}>
					{renderQuote()}
				</DropdownMenuItem>
			</DropdownMenuContent>
		</DropdownMenu>
	);
};

const TextFormatContainer = ({ editor }: { editor: EditorContextType }) => {
	return (
		<div className={`flex flex-wrap gap-1`}>
			<Button
				variant={`${editor.isBold ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleBold}
			>
				<Bold className={`h-4 w-4`} />
			</Button>
			<Button
				variant={`${editor.isItalic ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleItalic}
			>
				<Italic className={`h-4 w-4`} />
			</Button>
			<Button
				variant={`${editor.isUnderline ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleUnderline}
			>
				<Underline className={`h-4 w-4`} />
			</Button>
			<Button
				variant={`${editor.isStrikethrough ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleStrikethrough}
			>
				<Strikethrough className={`h-4 w-4`} />
			</Button>
			<Button
				variant={`${editor.isSuperscript ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleSuperscript}
			>
				<Superscript className={`h-4 w-4`} />
			</Button>
			<Button
				variant={`${editor.isSubscript ? "secondary" : "ghost"}`}
				size={"icon"}
				onClick={editor.toggleSubscript}
			>
				<Subscript className={`h-4 w-4`} />
			</Button>
		</div>
	);
};

const FontStyleContainer = ({ editor }: { editor: EditorContextType }) => {
	return (
		<div className={`flex gap-1`}>
			{/* font */}
			{/* font-size */}
		</div>
	);
};

const ColorContainer = ({ editor }: { editor: EditorContextType }) => {
	return (
		<div className={`flex gap-1`}>
			{/* background-color */}
			{/* text-color */}
		</div>
	);
};

export const ToolbarPlugin = ({}) => {
	const editor = useEditor();

	return (
		<div className={`flex p-2 gap-1 border-b border-slate-300`}>
			<UndoRedoContainer editor={editor} />
			<BlockTypeContainer editor={editor} />
			<TextFormatContainer editor={editor} />
		</div>
	);
};
