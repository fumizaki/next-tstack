"use client";

import {
	Page,
	PageHeader,
	PageTitle,
	PageSection,
	PageLoading,
} from "@/components/page";
import { useState } from "react";
import { Editor } from "@/components/rich-text";

export default function RichTextEditor() {
	const [text, setText] = useState<string>("");
	return (
		<Page>
			<PageHeader>
				<PageTitle title={"RichTextEditor"} />
			</PageHeader>
			<PageSection id={"rich-text-editor"}>
				<Editor value={text} onChange={(v) => setText(v)} />
			</PageSection>
		</Page>
	);
}
