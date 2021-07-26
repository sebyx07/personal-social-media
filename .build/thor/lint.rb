# frozen_string_literal: true

class Lint < Thor
  include Thor::Actions

  desc "default", "lint everything"
  def default
    threads = run_threaded("bundle exec rubocop -A", "bundle exec erblint --lint-all -a", "yarn lint")
    threads.each(&:join)
  end
  no_commands do
    def run_threaded(*cmds)
      cmds.map do |cmd|
        Thread.new do
          run cmd
        end
      end
    end
  end

  default_task :default
end
