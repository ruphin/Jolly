SimpleCov.start do
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /^lib\/jolly/
  end
  coverage_dir('coverage')
end
