class Auth

  ALGORITHM = 'HS256'

  def self.encrypt(hash)
    JWT.encode(hash, secret_key, ALGORITHM)
  end

  def self.decode(payload)
    JWT.decode(payload, secret_key, true, {algorithm: ALGORITHM}).first
  end

  def self.secret_key
    "d4269c3a3b398814de0db3c583450a5989b5930bd01926dbc30228c355c9b7c00bdf6a1f90bba80b20280bcc222828e530241ff5ad76370794a3c9c2cbd28cd0"
  end

end
