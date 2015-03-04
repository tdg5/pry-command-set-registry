require "test_helper"

class CommandSetTest < PryCommandSetRegistry::TestCase
  Subject = PryCommandSetRegistry::CommandSet

  context "instance methods" do
    context "#initialize" do
      setup do
        @name = "Foo"
        @description = "Bar"
        @command_set_proc = default_command_set_proc
      end

      should "create a new instance from the given arguments" do
        instance = Subject.new(@name, @description, &@command_set_proc)

        assert_equal @name, instance.name
        assert_equal @description, instance.description
        assert_equal true, @command_set_proc_obj[:proc_called]
      end

      should "correctly initialize the command set" do
        instance = Subject.new(@name, @description, &@command_set_proc)
        instance.run_command({}, "test")
        assert_equal true, @command_set_proc_obj[:command_called]
      end

      should "correctly set group names" do
        instance = Subject.new(@name, @description, &@command_set_proc)
        assert_equal @name, instance.commands.values.first.group
      end
    end
  end

  # Proc is called with instance eval, so closure must be used to allow
  # referencing in test and in command proc.
  def default_command_set_proc
    @command_set_proc_obj = closure_obj = {
      :command_called => false,
      :proc_called => false,
    }
    proc do
      closure_obj[:proc_called] = true
      command("test", "test command") do
        closure_obj[:command_called] = true
      end
    end
  end
end
