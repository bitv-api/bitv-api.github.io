# Unique header generation
require './lib/unique_head.rb'

# Markdown
set :markdown_engine, :redcarpet
set :markdown,
    fenced_code_blocks: true,
    smartypants: true,
    disable_indented_code_blocks: true,
    prettify: true,
    strikethrough: true,
    tables: true,
    with_toc_data: true,
    no_intra_emphasis: true,
    renderer: UniqueHeadCounter

# Assets
set :css_dir,  'stylesheets'
set :js_dir,   'javascripts'
set :images_dir, 'images'
set :fonts_dir,  'fonts'
set :layouts_dir, 'layouts'

# 让 SassC 能找到 partials，并禁用所有 asset-helper
set :sass,
    load_paths: [File.join(root, 'source', 'stylesheets')],
    line_comments: false,
    style: :compressed,
    functions: {}          # ← 关键：彻底关掉 font-url/image-url

# 语法高亮
activate :syntax
ready { require './lib/multilang.rb' }

# 其他常用扩展
activate :sprockets
activate :autoprefixer do |c|
  c.browsers = ['last 2 version', 'Firefox ESR']
  c.cascade  = false
  c.inline   = true
end
activate :relative_assets
set :relative_links, true

# 构建优化
configure :build do
  activate :minify_css
  activate :minify_javascript
end

# 端口与辅助方法
set :port, 4567
helpers { require './lib/toc_data.rb' }

# 关键：把 SassC 的 include_path 指向 stylesheets 目录
require 'sassc'
SassC.load_paths.unshift File.expand_path('source/stylesheets', __dir__)



# 兜底：让 font-url / image-url 直接返回原路径
#require 'sassc'

#module SassC::Script::Functions
#  def font_url(path, *args)
#    SassC::Script::Value::String.new("url(#{path})")
#  end

#  def image_url(path, *args)
#    SassC::Script::Value::String.new("url(#{path})")
#  end
#end
