module Mutant
  # Subject of a mutation
  class Subject
    include AbstractType, Adamantium::Flat, Enumerable
    include Concord::Public.new(:context, :node)

    # Return mutations
    #
    # @return [Enumerable<Mutation>]
    # @return [undefined]
    #
    # @api private
    #
    def mutations
      mutations = [neutral_mutation]
      Mutator.each(node) do |mutant|
        mutations << Mutation::Evil.new(self, wrap_node(mutant))
      end
      mutations
    end
    memoize :mutations

    # Return source path
    #
    # @return [String]
    #
    # @api private
    #
    def source_path
      context.source_path
    end

    # Prepare the subject for the insertion of mutation
    #
    # @return [self]
    #
    # @api private
    #
    def prepare
      self
    end

    # Return source lines
    #
    # @return [Range<Fixnum>]
    #
    # @api private
    #
    def source_lines
      expression = node.location.expression
      expression.line..expression.source_buffer.decompose_position(expression.end_pos).first
    end
    memoize :source_lines

    # Return source line
    #
    # @return [Fixnum]
    #
    # @api private
    #
    def source_line
      source_lines.begin
    end

    # Return subject identification
    #
    # @return [String]
    #
    # @api private
    #
    def identification
      "#{expression.syntax}:#{source_path}:#{source_line}"
    end
    memoize :identification

    # Return source representation of ast
    #
    # @return [String]
    #
    # @api private
    #
    def source
      Unparser.unparse(wrap_node(node))
    end
    memoize :source

    # Return match expression
    #
    # @return [Expression]
    #
    # @api private
    #
    abstract_method :expression

    # Return match expressions
    #
    # @return [Enumerable<Expression>]
    #
    # @api private
    #
    abstract_method :match_expressions

  private

    # Return neutral mutation
    #
    # @return [Mutation::Neutral]
    #
    # @api private
    #
    def neutral_mutation
      Mutation::Neutral.new(self, wrap_node(node))
    end

    # Wrap node into subject specific container
    #
    # @param [Parser::AST::Node] node
    #
    # @return [Parser::AST::Node]
    #
    # @api private
    #
    def wrap_node(node)
      node
    end

  end # Subject
end # Mutant
