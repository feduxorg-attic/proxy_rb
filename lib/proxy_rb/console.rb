require 'irb'

require 'proxy_rb/console/help'
require 'proxy_rb/api'

# ProxyRb
module ProxyRb
  # Consule
  class Console
    # Start the proxy_rb console
    #
    # rubocop:disable Metrics/MethodLength
    def start
      # Start IRB with current context:
      # http://stackoverflow.com/questions/4189818/how-to-run-irb-start-in-context-of-current-class
      ARGV.clear
      IRB.setup nil

      IRB.conf[:IRB_NAME] = 'proxy_rb'

      IRB.conf[:PROMPT] = {}
      IRB.conf[:PROMPT][:PROXY_RB] = {
        :PROMPT_I => '%N:%03n:%i> ',
        :PROMPT_S => '%N:%03n:%i%l ',
        :PROMPT_C => '%N:%03n:%i* ',
        :RETURN => "# => %s\n"
      }
      IRB.conf[:PROMPT_MODE] = :PROXY_RB

      IRB.conf[:RC] = false

      require 'irb/completion'
      require 'irb/ext/save-history'
      IRB.conf[:READLINE] = true
      IRB.conf[:SAVE_HISTORY] = 1000
      IRB.conf[:HISTORY_FILE] = ProxyRb.config.console_history_file

      # rubocop:disable Lint/NestedMethodDefinition
      context = Class.new do
        include ProxyRb::Console::Help
        include ProxyRb::Api

        def inspect
          'nil'
        end
      end
      # rubocop:enable Lint/NestedMethodDefinition

      irb = IRB::Irb.new(IRB::WorkSpace.new(context.new))
      IRB.conf[:MAIN_CONTEXT] = irb.context

      trap("SIGINT") do
        irb.signal_handle
      end

      begin
        catch(:IRB_EXIT) do
          irb.eval_input
        end
      ensure
        IRB.irb_at_exit
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
