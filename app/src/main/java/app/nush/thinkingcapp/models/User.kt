package app.nush.thinkingcapp.models

data class User(
    val email: String = "",
    val username: String = email,
) : Storable {
    override val id: String
        get() = email
}

fun List<User>.findByEmail(email: String): User {
    return this.find { it.email == email } ?: User(email, email)
}
