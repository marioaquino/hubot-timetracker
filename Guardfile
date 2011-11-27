guard 'coffeescript', :output => 'scripts-js' do
  watch /^scripts\/(.*)\.coffee$/
end

guard 'coffeescript', :output => 'spec/javascripts' do
  watch /^spec\/coffeescripts\/(.*)\.coffee$/
  watch /^spec\/coffeescripts\/helpers\/(.*)\.coffee$/
end

guard 'livereload' do
  watch /^spec\/javascripts\/.+\.js$/
  watch /^scripts-js\/.+\.js$/
end

