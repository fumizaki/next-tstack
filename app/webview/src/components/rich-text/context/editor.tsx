import React, {
    createContext,
    useCallback,
    useContext,
    useEffect,
    useMemo,
    useState,
} from 'react';
import { useLexicalComposerContext } from '@lexical/react/LexicalComposerContext';
import {
    $createParagraphNode,
    $getSelection,
    $isRangeSelection,
    $isRootOrShadowRoot,
    LexicalNode,
    COMMAND_PRIORITY_CRITICAL,
    CAN_REDO_COMMAND,
    CAN_UNDO_COMMAND,
    UNDO_COMMAND,
    REDO_COMMAND,
    FORMAT_TEXT_COMMAND,
} from 'lexical';
import { $findMatchingParent, $getNearestNodeOfType, mergeRegister } from '@lexical/utils';
import {
    $setBlocksType,
} from '@lexical/selection';
import {
    ListNode,
    $isListNode,
    INSERT_CHECK_LIST_COMMAND,
    INSERT_ORDERED_LIST_COMMAND,
    INSERT_UNORDERED_LIST_COMMAND,
    REMOVE_LIST_COMMAND,
} from '@lexical/list';
import { $createHeadingNode, $createQuoteNode, $isHeadingNode, $isQuoteNode, HeadingTagType } from '@lexical/rich-text';

export const BLOCK_TYPES = {
    P: 'paragraph',
    H1: 'h1',
    H2: 'h2',
    H3: 'h3',
    H4: 'h4',
    H5: 'h5',
    H6: 'h6',
    QUOTE: 'quote',
    CODE: 'code',
    UL: 'bullet',
    OL: 'number',
    CL: 'check',
} as const;

type BlockType = (typeof BLOCK_TYPES)[keyof typeof BLOCK_TYPES];

type ListType = 'bullet' | 'number' | 'check'
type HeadingType = 'h1' | 'h2' | 'h3' | 'h4' | 'h5' | 'h6'
type TextFormatType = 'bold' | 'italic' | 'underline' | 'strikethrough' | 'subscript' | 'superscript' | 'code'

interface EditorState {
    blockType: BlockType
    isHeading1: boolean
    isHeading2: boolean
    isHeading3: boolean
    isQuote: boolean
    isBold: boolean;
    isItalic: boolean;
    isUnderline: boolean;
    isStrikethrough: boolean;
    isSubscript: boolean;
    isSuperscript: boolean;
    isCode: boolean;
    isBulletList: boolean
    isNumberList: boolean
    isCheckList: boolean
    textFormat: Record<TextFormatType, boolean>
    canUndo: boolean
    canRedo: boolean
}

interface EditorActions {
    toggleParagraph: () => void
    toggleHeading: (headingTag: HeadingTagType) => void
    toggleQuote: () => void
    toggleBold: () => void;
    toggleItalic: () => void;
    toggleUnderline: () => void;
    toggleStrikethrough: () => void;
    toggleSubscript: () => void;
    toggleSuperscript: () => void;
    toggleCode: () => void;
    toggleBulletList: () => void
    toggleNumberList: () => void
    toggleCheckList: () => void
    toggleTextFormat: (format: TextFormatType) => void
    undo: () => void
    redo: () => void
}

export type EditorContextType = EditorState & EditorActions

const initialState: EditorState = {
    blockType: BLOCK_TYPES.P,
    isHeading1: false,
    isHeading2: false,
    isHeading3: false,
    isQuote: false,
    isBold: false,
    isItalic: false,
    isUnderline: false,
    isStrikethrough: false,
    isSubscript: false,
    isSuperscript: false,
    isCode: false,
    isBulletList: false,
    isNumberList: false,
    isCheckList: false,
    textFormat: {
        bold: false,
        italic: false,
        underline: false,
        strikethrough: false,
        subscript: false,
        superscript: false,
        code: false,
    },
    canUndo: false,
    canRedo: false,
}

const EditorContext = createContext<EditorContextType>({
    ...initialState,
    toggleParagraph: () => null,
    toggleHeading: () => null,
    toggleQuote: () => null,
    toggleBold: () => {},
    toggleItalic: () => {},
    toggleUnderline: () => {},
    toggleStrikethrough: () => {},
    toggleSubscript: () => {},
    toggleSuperscript: () => {},
    toggleCode: () => {},
    toggleBulletList: () => null,
    toggleNumberList: () => null,
    toggleCheckList: () => null,
    toggleTextFormat: () => null,
    undo: () => null,
    redo: () => null,
})

const getTargetNode = (node: LexicalNode) => {
    return node.getKey() === 'root'
        ? node
        : $findMatchingParent(node, (parent: LexicalNode) => {
              const parentNode = parent.getParent()
              return parentNode !== null && $isRootOrShadowRoot(parentNode)
          })
}

export function EditorProvider({ children }: { children: React.ReactNode }) {
    const [editor] = useLexicalComposerContext()
    const [editorState, setEditorState] = useState<EditorState>(initialState)

    const updateEditorState = useCallback(() => {
        editor.getEditorState().read(() => {
            const selection = $getSelection()
            if (!$isRangeSelection(selection)) return

            const anchorNode = selection.anchor.getNode()
            const targetNode = getTargetNode(anchorNode)

            // Update text format states
            const textFormat = {
                bold: selection.hasFormat('bold'),
                italic: selection.hasFormat('italic'),
                underline: selection.hasFormat('underline'),
                strikethrough: selection.hasFormat('strikethrough'),
                subscript: selection.hasFormat('subscript'),
                superscript: selection.hasFormat('superscript'),
                code: selection.hasFormat('code'),
            }

            // Update block type state
            let blockType: BlockType = BLOCK_TYPES.P
            if ($isListNode(targetNode)) {
                const parentList = $getNearestNodeOfType<ListNode>(anchorNode, ListNode)
                const listType = (parentList ? parentList.getListType() : targetNode.getListType()) as ListType

                // リストタイプをBlockTypeにマッピング
                switch (listType) {
                    case 'bullet':
                        blockType = BLOCK_TYPES.UL
                        break
                    case 'number':
                        blockType = BLOCK_TYPES.OL
                        break
                    case 'check':
                        blockType = BLOCK_TYPES.CL
                        break
                    default:
                        blockType = BLOCK_TYPES.P
                }
                blockType = parentList ? parentList.getListType() : targetNode.getListType()
            } else if ($isHeadingNode(targetNode)) {
                blockType = targetNode.getTag()
            } else if ($isQuoteNode(targetNode)) {
                blockType = BLOCK_TYPES.QUOTE
            }

            setEditorState(prev => ({
                ...prev,
                blockType,
                isHeading1: blockType === BLOCK_TYPES.H1,
                isHeading2: blockType === BLOCK_TYPES.H2,
                isHeading3: blockType === BLOCK_TYPES.H3,
                isQuote: blockType === BLOCK_TYPES.QUOTE,
                isBulletList: blockType === BLOCK_TYPES.UL,
                isNumberList: blockType === BLOCK_TYPES.OL,
                isCheckList: blockType === BLOCK_TYPES.CL,
                textFormat,
            }))
        })
    }, [editor])

    useEffect(() => {
        return mergeRegister(
            editor.registerUpdateListener(() => {
                updateEditorState()
            }),
            editor.registerCommand(
                CAN_UNDO_COMMAND,
                (payload) => {
                    setEditorState(prev => ({ ...prev, canUndo: payload }))
                    return false
                },
                COMMAND_PRIORITY_CRITICAL
            ),
            editor.registerCommand(
                CAN_REDO_COMMAND,
                (payload) => {
                    setEditorState(prev => ({ ...prev, canRedo: payload }))
                    return false
                },
                COMMAND_PRIORITY_CRITICAL
            )
        )
    }, [editor, updateEditorState])

    const toggleParagraph = useCallback(() => {
        editor.update(() => {
            const selection = $getSelection()
            if (selection) {
                $setBlocksType(selection, () => $createParagraphNode())
            }
        })
    }, [editor])

    const toggleHeading = useCallback((headingTag: HeadingTagType) => {
        editor.update(() => {
            const selection = $getSelection()
            if (selection) {
                $setBlocksType(selection, () => $createHeadingNode(headingTag))
            }
        })
    }, [editor])

    const toggleQuote = useCallback(() => {
        editor.update(() => {
            const selection = $getSelection()
            if (selection) {
                $setBlocksType(selection, () => $createQuoteNode())
            }
        })
    }, [editor])


    const toggleBold = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'bold');
    }, [editor]);

    const toggleItalic = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'italic');
    }, [editor]);

    const toggleUnderline = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'underline');
    }, [editor]);

    const toggleStrikethrough = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'strikethrough');
    }, [editor]);

    const toggleSubscript = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'subscript');
    }, [editor]);

    const toggleSuperscript = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'superscript');
    }, [editor]);

    const toggleCode = useCallback(() => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'code');
    }, [editor]);


    const toggleBulletList = useCallback(() => {
        if (editorState.blockType !== BLOCK_TYPES.UL) {
            editor.dispatchCommand(INSERT_UNORDERED_LIST_COMMAND, undefined)
        } else {
            editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined)
        }
    }, [editor, editorState.blockType])

    const toggleNumberList = useCallback(() => {
        if (editorState.blockType !== BLOCK_TYPES.OL) {
            editor.dispatchCommand(INSERT_ORDERED_LIST_COMMAND, undefined)
        } else {
            editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined)
        }
    }, [editor, editorState.blockType])

    const toggleCheckList = useCallback(() => {
        if (editorState.blockType !== BLOCK_TYPES.CL) {
            editor.dispatchCommand(INSERT_CHECK_LIST_COMMAND, undefined)
        } else {
            editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined)
        }
    }, [editor, editorState.blockType])

    const toggleTextFormat = useCallback((format: TextFormatType) => {
        editor.dispatchCommand(FORMAT_TEXT_COMMAND, format)
    }, [editor])

    const undo = useCallback(() => {
        editor.dispatchCommand(UNDO_COMMAND, undefined)
    }, [editor])

    const redo = useCallback(() => {
        editor.dispatchCommand(REDO_COMMAND, undefined)
    }, [editor])

    const contextValue = useMemo(
        () => ({
            ...editorState,
            toggleParagraph,
            toggleHeading,
            toggleQuote,
            toggleBold,
            toggleItalic,
            toggleUnderline,
            toggleStrikethrough,
            toggleSubscript,
            toggleSuperscript,
            toggleCode,
            toggleBulletList,
            toggleNumberList,
            toggleCheckList,
            toggleTextFormat,
            undo,
            redo,
        }),
        [
            editorState,
            toggleParagraph,
            toggleHeading,
            toggleQuote,
            toggleBold,
            toggleItalic,
            toggleUnderline,
            toggleStrikethrough,
            toggleSubscript,
            toggleSuperscript,
            toggleCode,
            toggleBulletList,
            toggleNumberList,
            toggleCheckList,
            toggleTextFormat,
            undo,
            redo,
        ]
    )

    return (
        <EditorContext.Provider value={contextValue}>
            {children}
        </EditorContext.Provider>
    )
}

export const useEditor = () => useContext(EditorContext)

// export type ConditionContextProps = {
//     blockType: BlockType;
//     // isHeading1: boolean;
//     isHeading2: boolean;
//     isHeading3: boolean;
//     isHeading4: boolean;
//     isHeading5: boolean;
//     isHeading6: boolean;
//     isUnOrderList: boolean;
//     isOrderList: boolean;
//     isCheckList: boolean;
//     isQuote: boolean;
//     isBold: boolean;
//     isItalic: boolean;
//     isUnderline: boolean;
//     isStrikethrough: boolean;
//     isSubscript: boolean;
//     isSuperscript: boolean;
//     isCode: boolean;
//     canUndo: boolean;
//     canRedo: boolean;
//     toggleParagraph: () => void;
//     toggleHeading: (headingTag: HeadingTagType) => void;
//     toggleUnOrderList: () => void;
//     toggleOrderList: () => void;
//     toggleCheckList: () => void;
//     toggleQuote: () => void;
//     toggleBold: () => void;
//     toggleItalic: () => void;
//     toggleUnderline: () => void;
//     toggleStrikethrough: () => void;
//     toggleSubscript: () => void;
//     toggleSuperscript: () => void;
//     toggleCode: () => void;
//     undo: () => void;
//     redo: () => void;
// };

// const ConditionContext = createContext<ConditionContextProps>({
//     blockType: BLOCK_TYPES.P,
//     isHeading2: false,
//     isHeading3: false,
//     isHeading4: false,
//     isHeading5: false,
//     isHeading6: false,
//     isUnOrderList: false,
//     isOrderList: false,
//     isCheckList: false,
//     isQuote: false,
//     isBold: false,
//     isItalic: false,
//     isUnderline: false,
//     isStrikethrough: false,
//     isSubscript: false,
//     isSuperscript: false,
//     isCode: false,
//     canUndo: false,
//     canRedo: false,
//     toggleParagraph: () => {},
//     toggleHeading: () => {},
//     toggleUnOrderList: () => {},
//     toggleOrderList: () => {},
//     toggleCheckList: () => {},
//     toggleQuote: () => {},
//     toggleBold: () => {},
//     toggleItalic: () => {},
//     toggleUnderline: () => {},
//     toggleStrikethrough: () => {},
//     toggleSubscript: () => {},
//     toggleSuperscript: () => {},
//     toggleCode: () => {},
//     undo: () => {},
//     redo: () => {},
// });

// const useProvideCondition = (): ConditionContextProps => {
//     const [blockType, setBlockType] = useState<BlockType>(BLOCK_TYPES.P);
//     const [editor] = useLexicalComposerContext();
//     const [canUndo, setCanUndo] = useState<boolean>(false);
//     const [canRedo, setCanRedo] = useState<boolean>(false);
//     const [isBold, setIsBold] = useState<boolean>(false);
//     const [isItalic, setIsItalic] = useState<boolean>(false);
//     const [isUnderline, setIsUnderline] = useState<boolean>(false);
//     const [isStrikethrough, setIsStrikethrough] = useState<boolean>(false);
//     const [isSubscript, setIsSubscript] = useState<boolean>(false);
//     const [isSuperscript, setIsSuperscript] = useState<boolean>(false);
//     const [isCode, setIsCode] = useState<boolean>(false);

//     const updateCondition = useCallback(() => {
//         const selection = $getSelection();
//         if (!$isRangeSelection(selection)) return;

//         const anchorNode = selection.anchor.getNode();
//         const targetNode = getSecondRootNode(anchorNode);

//         setIsBold(selection.hasFormat('bold'));
//         setIsItalic(selection.hasFormat('italic'));
//         setIsUnderline(selection.hasFormat('underline'));
//         setIsStrikethrough(selection.hasFormat('strikethrough'));
//         setIsSubscript(selection.hasFormat('subscript'));
//         setIsSuperscript(selection.hasFormat('superscript'));
//         setIsCode(selection.hasFormat('code'));

//         if ($isListNode(targetNode)) {
//             const parentList = $getNearestNodeOfType<ListNode>(anchorNode, ListNode);
//             const type = parentList ? parentList.getListType() : targetNode.getListType();
//             setBlockType(type);
//             return;
//         } else if ($isHeadingNode(targetNode)) {
//             const type = $isHeadingNode(targetNode) ? targetNode.getTag() : BLOCK_TYPES.P;
//             setBlockType(type);
//             return;
//         } else {
//             setBlockType(BLOCK_TYPES.P);
//         }
//     }, []);

//     // useEffect(() => {
//     //     console.log(editor);
//     // }, [editor]);

//     useEffect(() => {
//         editor.registerUpdateListener(({ editorState }) => {
//             editorState.read(() => {
//                 updateCondition();
//             });
//         });

//         editor.registerCommand<boolean>(
//             CAN_UNDO_COMMAND,
//             (payload) => {
//                 setCanUndo(payload);
//                 return false;
//             },
//             COMMAND_PRIORITY_CRITICAL,
//         );

//         editor.registerCommand<boolean>(
//             CAN_REDO_COMMAND,
//             (payload) => {
//                 setCanRedo(payload);
//                 return false;
//             },
//             COMMAND_PRIORITY_CRITICAL,
//         );
//     }, [editor, updateCondition]);

//     const toggleUnOrderList = useCallback(() => {
//         if (blockType !== BLOCK_TYPES.UL) {
//             editor.dispatchCommand(INSERT_UNORDERED_LIST_COMMAND, undefined);
//             return;
//         }
//         editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined);
//     }, [editor, blockType]);

//     const toggleOrderList = useCallback(() => {
//         if (blockType !== BLOCK_TYPES.OL) {
//             editor.dispatchCommand(INSERT_ORDERED_LIST_COMMAND, undefined);
//             return;
//         }
//         editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined);
//     }, [editor, blockType]);

//     const toggleCheckList = useCallback(() => {
//         if (blockType !== BLOCK_TYPES.CL) {
//             editor.dispatchCommand(INSERT_CHECK_LIST_COMMAND, undefined);
//             return;
//         }
//         editor.dispatchCommand(REMOVE_LIST_COMMAND, undefined);
//     }, [editor, blockType]);

//     const toggleHeading = useCallback(
//         (headingTag: HeadingTagType) => {
//             if (blockType !== headingTag) {
//                 editor.update(() => {
//                     const selection = $getSelection();
//                     if (selection !== null) {
//                         $setBlocksType(selection, () => $createHeadingNode(headingTag));
//                     }
//                 });
//             }
//         },
//         [editor, blockType],
//     );

//     const toggleQuote = useCallback(() => {
//         if (blockType !== BLOCK_TYPES.QUOTE) {
//             editor.update(() => {
//                 const selection = $getSelection();
//                 if (selection !== null) {
//                     $setBlocksType(selection, () => $createQuoteNode());
//                 }
//             });
//         }
//     }, [editor, blockType]);

//     const toggleParagraph = useCallback(() => {
//         if (blockType !== BLOCK_TYPES.P) {
//             editor.update(() => {
//                 const selection = $getSelection();
//                 if (selection !== null) {
//                     $setBlocksType(selection, () => $createParagraphNode());
//                 }
//             });
//         }
//     }, [editor, blockType]);

//     const toggleBold = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'bold');
//     }, [editor]);

//     const toggleItalic = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'italic');
//     }, [editor]);

//     const toggleUnderline = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'underline');
//     }, [editor]);

//     const toggleStrikethrough = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'strikethrough');
//     }, [editor]);

//     const toggleSubscript = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'subscript');
//     }, [editor]);

//     const toggleSuperscript = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'superscript');
//     }, [editor]);

//     const toggleCode = useCallback(() => {
//         editor.dispatchCommand(FORMAT_TEXT_COMMAND, 'code');
//     }, [editor]);

//     const undo = useCallback(() => {
//         editor.dispatchCommand(UNDO_COMMAND, undefined);
//     }, [editor]);

//     const redo = useCallback(() => {
//         editor.dispatchCommand(REDO_COMMAND, undefined);
//     }, [editor]);

//     const [
//         isHeading2,
//         isHeading3,
//         isHeading4,
//         isHeading5,
//         isHeading6,
//         isUnOrderList,
//         isOrderList,
//         isCheckList,
//         isQuote,
//     ] = useMemo(
//         () => [
//             blockType === BLOCK_TYPES.H2,
//             blockType === BLOCK_TYPES.H3,
//             blockType === BLOCK_TYPES.H4,
//             blockType === BLOCK_TYPES.H5,
//             blockType === BLOCK_TYPES.H6,
//             blockType === BLOCK_TYPES.UL,
//             blockType === BLOCK_TYPES.OL,
//             blockType === BLOCK_TYPES.CL,
//             blockType === BLOCK_TYPES.QUOTE,
//         ],
//         [blockType],
//     );

//     return {
//         blockType,
//         isHeading2,
//         isHeading3,
//         isHeading4,
//         isHeading5,
//         isHeading6,
//         isUnOrderList,
//         isOrderList,
//         isCheckList,
//         isQuote,
//         isBold,
//         isItalic,
//         isUnderline,
//         isStrikethrough,
//         isSubscript,
//         isSuperscript,
//         isCode,
//         canUndo,
//         canRedo,
//         toggleParagraph,
//         toggleHeading,
//         toggleUnOrderList,
//         toggleOrderList,
//         toggleCheckList,
//         toggleQuote,
//         toggleBold,
//         toggleItalic,
//         toggleUnderline,
//         toggleStrikethrough,
//         toggleSubscript,
//         toggleSuperscript,
//         toggleCode,
//         undo,
//         redo,
//     };
// };

// const getSecondRootNode = (targetNode: LexicalNode) => {
//     return targetNode.getKey() === 'root'
//         ? targetNode
//         : $findMatchingParent(targetNode, (node: LexicalNode) => {
//               const parentNode = node.getParent();
//               return parentNode !== null && $isRootOrShadowRoot(parentNode);
//           });
// };

// export const ConditionProvider = ({ children }: { children: React.ReactNode }) => {
//     const value = useProvideCondition();

//     return <ConditionContext.Provider value={value}>{children}</ConditionContext.Provider>;
// };

// export const useCondition = () => {
//     return useContext(ConditionContext);
// };