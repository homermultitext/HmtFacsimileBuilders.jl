
abstract type OutputFormat end

struct HtmlOutput <: OutputFormat end
const HTML = HtmlOutput()

struct MarkdownOutput <: OutputFormat end
const MARKDOWN = MarkdownOutput()