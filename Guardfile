group :server do
  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end

  guard 'livereload' do
    watch(%r{app/.+\.(erb|haml)})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{(public/|app/assets).+\.(css|js|html)})
    watch(%r{(app/assets/.+\.css)\.s[ac]ss}) { |m| m[1] }
    watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
    watch(%r{(app/assets/.+\.jst)\.ejs}) { |m| m[1] }
    watch(%r{config/locales/.+\.yml})
  end
end





