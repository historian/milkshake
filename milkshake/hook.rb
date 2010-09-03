def framework_public_dir
  File.expand_path(
    "../../lib/milkshake/frameworks/#{active_framework}/public",
    __FILE__)
end

def run
  bind(framework_public_dir, "public", :glob => '**/*.*')
  bind('gem:public',    'public', :fall_through => true, :glob => '**/*.*')

  directory('private/uploaded')
  link('app:private/uploaded', 'public/system', :glob => '')
end