guard 'rspec', :version => 2, :bundler => false, :all_on_start => false, :all_after_pass => false do
  watch(/^spec\/(.*)_spec.rb/)
  watch(/^app\/(.*)\.rb/)                                { |m| "spec/#{m[1]}_spec.rb" }
  watch(/^lib\/(.*)\.rb/)                                { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(/^config\/routes.rb/)                            { "spec/routing" }
  watch(/^app\/controllers\/application_controller\.rb/) { "spec/controllers" }
  watch(/^spec\/support\/controller_spec_helpers\.rb/)   { "spec/controllers" }
  watch(/^spec\/factories\.rb/)                          { "spec/models" }
  watch(/^spec\/spec_helper\.rb/)                        { "spec" }
end
