package app.nush.thinkingcapp.models

data class User(
    val admin: Boolean = false,
    val email: String = "",
    val username: String = email
) : Storable {
    override val id: String
        get() = email
}

fun List<User>.findByEmail(email: String): User {
    return this.find { it.email == email } ?: User(false, email, email)
}
