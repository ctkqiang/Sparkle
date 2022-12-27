require 'git'

class GitClient 
    def clone(url)
        Git.clone(url, 'clone.git')
    end
end