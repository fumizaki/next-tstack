import { useState, useEffect } from 'react';
import { LexicalEditor, EditorState, $getRoot, $insertNodes } from 'lexical';
import { LexicalErrorBoundary } from '@lexical/react/LexicalErrorBoundary';
import { LexicalComposer } from '@lexical/react/LexicalComposer';
import { RichTextPlugin } from '@lexical/react/LexicalRichTextPlugin';
import { ContentEditable } from '@lexical/react/LexicalContentEditable';
import { OnChangePlugin } from '@lexical/react/LexicalOnChangePlugin';
import { ListPlugin } from '@lexical/react/LexicalListPlugin';
import { LinkPlugin } from '@lexical/react/LexicalLinkPlugin';
import { HistoryPlugin } from '@lexical/react/LexicalHistoryPlugin';
import { CheckListPlugin } from '@lexical/react/LexicalCheckListPlugin';
import { $generateHtmlFromNodes, $generateNodesFromDOM } from '@lexical/html';
import { AutoLinkNode, LinkNode } from '@lexical/link';
import { ListNode, ListItemNode } from '@lexical/list';
import { HeadingNode, QuoteNode } from '@lexical/rich-text';
import { ToolbarPlugin, AutoLinkPlugin } from '@/components/rich-text/plugin';
import { EditorProvider } from '@/components/rich-text/context/editor';
import { EditorTheme } from '@/components/rich-text/theme';
import { Card, CardHeader, CardContent } from '@/components/ui/card'

interface Props {
    value: string | null;
    onChange: (value: string) => void;
}

export const RichTextEditor = ({ value, onChange }: Props) => {
    const [isMounted, setIsMounted] = useState(false);

    useEffect(() => {
        setIsMounted(true);
    }, []);

    if (!isMounted) {
        return <p>loading</p>;
    }

    const generateHtml = (editorState: EditorState, editor: LexicalEditor) => {
        const html = editorState.read(() => $generateHtmlFromNodes(editor));
        onChange(html);
    };

    const onError = (e: Error) => {
        console.log(e);
    };

    return (
        <Card>
            <LexicalComposer
                initialConfig={{
                    namespace: 'RichTextEditor',
                    theme: EditorTheme,
                    editorState: (editor: LexicalEditor) => {
                        editor.update(() => {
                            const parser = new DOMParser();
                            const dom = parser.parseFromString(value ?? '', 'text/html');
                            const nodes = $generateNodesFromDOM(editor, dom);
                            $getRoot().select();
                            $insertNodes(nodes);
                        });
                    },
                    onError,
                    nodes: [ListNode, ListItemNode, HeadingNode, QuoteNode, LinkNode, AutoLinkNode],
                }}
            >
                <CardHeader>
                    <EditorProvider>
                        <ToolbarPlugin />
                    </EditorProvider>
                </CardHeader>
                <CardContent className={'relative'}>
                    <RichTextPlugin
                        contentEditable={
                            <ContentEditable
                                className={`text-base border-none outline-none select-none min-h-[300px] overflow-auto resize-y`}
                            />
                        }
                        placeholder={<p className={'absolute top-0 text-gray-500'}>入力してください</p>}
                        ErrorBoundary={LexicalErrorBoundary}
                    />
                    <OnChangePlugin onChange={generateHtml} />
                    <HistoryPlugin />
                    <ListPlugin />
                    <CheckListPlugin />
                    <LinkPlugin />
                    <AutoLinkPlugin />
                </CardContent>
            </LexicalComposer>
        </Card>
    );
};