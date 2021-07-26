# frozen_string_literal: true

class Ssh < Thor
  include Thor::Actions

  desc "default", "ssh"
  def default
    run "ssh deploy@161.97.82.148"
  end

  desc "test", "ssh"
  def test
    run "ssh root@167.86.83.55"
  end

  desc "test2", "ssh"
  def test2
    run "ssh root@161.97.64.223"
  end

  default_task :default
end
