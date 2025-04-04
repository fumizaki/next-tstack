import type { EditorThemeClasses } from "lexical";

export const EditorTheme: EditorThemeClasses = {
	blockCursor: "block-cursor",
	characterLimit: "text-gray-400",
	code: "bg-gray-100 p-2 rounded-md font-mono text-sm",
	codeHighlight: {
		atrule: "text-blue-600",
		attr: "text-purple-600",
		boolean: "text-red-500",
		builtin: "text-teal-600",
		cdata: "text-gray-600",
		char: "text-green-600",
		class: "text-purple-600",
		"class-name": "text-purple-600",
		comment: "text-gray-500 italic",
		constant: "text-orange-600",
		deleted: "text-red-500",
		doctype: "text-gray-600",
		entity: "text-yellow-600",
		function: "text-blue-600",
		important: "text-purple-600 font-bold",
		inserted: "text-green-600",
		keyword: "text-purple-600",
		namespace: "text-yellow-600",
		number: "text-orange-600",
		operator: "text-indigo-600",
		prolog: "text-gray-600",
		property: "text-blue-600",
		punctuation: "text-gray-600",
		regex: "text-red-600",
		selector: "text-green-600",
		string: "text-green-600",
		symbol: "text-purple-600",
		tag: "text-red-600",
		url: "text-blue-600 underline",
		variable: "text-yellow-600",
	},
	hashtag: "text-blue-500",
	heading: {
		h1: "text-4xl font-bold tracking-tight mb-4 scroll-m-20",
		h2: "text-3xl font-semibold tracking-tight mb-4 scroll-m-20",
		h3: "text-2xl font-semibold tracking-tight mb-3 scroll-m-20",
		h4: "text-xl font-semibold tracking-tight mb-3 scroll-m-20",
		h5: "text-lg font-semibold tracking-tight mb-2 scroll-m-20",
		h6: "text-base font-semibold tracking-tight mb-2 scroll-m-20",
	},
	hr: "my-4 border-t border-gray-200",
	image: "max-w-full h-auto rounded-lg",
	link: "text-primary underline hover:text-primary/80 transition-colors",
	list: {
		listitem: "ml-6 mb-1",
		listitemChecked:
			"relative ml-6 mb-1 list-none line-through text-muted-foreground",
		listitemUnchecked: "relative ml-6 mb-1 list-none",
		nested: {
			listitem: "ml-6 mb-1",
		},
		olDepth: [
			"list-decimal",
			"list-[upper-alpha]",
			"list-[lower-alpha]",
			"list-[upper-roman]",
			"list-[lower-roman]",
		],
		ul: "list-disc mb-4",
	},
	ltr: "text-left",
	mark: "bg-yellow-200 rounded-sm px-1",
	markOverlap: "bg-yellow-100",
	paragraph: "mb-2",
	quote: "border-l-4 border-gray-200 pl-4 my-4 italic text-gray-700",
	root: "prose dark:prose-invert max-w-none",
	rtl: "text-right",
	table: "w-full border-collapse border border-gray-200",
	tableAddColumns: "absolute right-0 top-0 flex items-center justify-center",
	tableAddRows: "absolute left-0 bottom-0 flex items-center justify-center",
	tableCellActionButton: "px-2 py-1 text-gray-500 hover:text-gray-700",
	tableCellActionButtonContainer:
		"absolute right-0 top-0 flex items-center justify-center",
	tableCellEditing: "relative p-2 border border-blue-500 outline-none",
	tableCellHeader:
		"bg-gray-100 font-semibold text-left p-2 border border-gray-200",
	tableCellPrimarySelected: "border-2 border-blue-500",
	tableCellResizer:
		"absolute right-0 top-0 w-1 h-full cursor-col-resize bg-blue-500",
	tableCellSelected: "bg-blue-100",
	tableCell: "relative p-2 border border-gray-200",
	tableCellSortedIndicator: "ml-1 text-gray-400",
	tableResizeRuler: "absolute w-px h-full bg-blue-500",
	tableRow: "border-b border-gray-200",
	tableSelected: "outline outline-2 outline-blue-500",
	text: {
		bold: "font-bold",
		code: "bg-gray-100 text-sm font-mono rounded px-1",
		italic: "italic",
		strikethrough: "line-through",
		subscript: "text-sm align-sub",
		superscript: "text-sm align-super",
		underline: "underline underline-offset-4",
		underlineStrikethrough: "underline line-through underline-offset-4",
	},
	embedBlock: {
		base: "relative p-4 bg-gray-100 rounded-lg",
		focus: "outline-none ring-2 ring-blue-500",
	},
	indent: "ml-4",
};
