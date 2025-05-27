class Mutations::Login < Mutations::BaseMutation
  argument :email, String, required: true
  argument :password, String, required: true

  field :token, String, null: false

  def resolve(email:, password:)
    user = User.find_by_email(email)

    if user&.authenticate(password)
      token = JWT.encode({ user_id: user.id }, 'testsecretcode', 'HS256')

      { token: token }
    else
      raise GraphQL::ExecutionError, "Invalid email or password"
    end
  end
end