import java.io.File

/**
 * Main class, read the config, download offers from source, send offers to lotto topic.
 */
fun main(args: Array<String>) =
    println("Valid passwords: ${Puzzle(File(Puzzle::class.java.getResource("./puzzle2[input]").file)).validPasswords()}")

class Puzzle(private val input: File) {
    fun validPasswords(): Int =
        input.readLines().filter {
            it.split(" ").run {
                val positions = this[0].split("-")
                val toFind = this[1].toCharArray().first()
                val password = this[2]
                (password[positions[0].toInt() - 1] == toFind).xor(password[positions[1].toInt() - 1] == toFind)
            }
        }.count()
}