module Rip
  module Runtime
    extend self
    extend Help

    o 'rip runtime add RUBY'
    x 'Add a new ruby.'
    def add(ruby)
    end

    o 'rip runtime use RUBY'
    x 'Activate a runtime.'
    def use(ruby)
    end

    o 'rip runtime active'
    x 'Show the active runtime'
    def active
    end

    o 'rip runtime list'
    x 'List all installed runtimes'
    def list
    end

    o 'rip runtime delete RUBY'
    x 'Remove a ruby runtime'
    def delete(ruby)
    end

    def commands
      %w( add use active list delete )
    end
  end
end