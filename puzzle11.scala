import scala.io.Source
import scala.collection.mutable.ListBuffer

object puzzle11 {
  val EMPTY_SEAT = 'L'
  val TAKEN_SEAT = '#'
  val FLOOR = '.'

  def main(args: Array[String]) {
    println("Part 1: " + musicalChairsWithCovid(false, 4).flatten.count(_ == TAKEN_SEAT))
    println("Part 2: " + musicalChairsWithCovid(true, 5).flatten.count(_ == TAKEN_SEAT))
  }

  def musicalChairsWithCovid(cautiouslyDistanced: Boolean, crowdingTolerance: Int): List[List[Char]] = {
    val offsets = List((-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0))
    var seats = Source.fromFile("puzzle11[input]").getLines().map(_.toList).toList
    var nextSeats = seats
    var changing = true

    while (changing) {
      changing = false
      seats.indices.foreach { row =>
        seats(row).indices.foreach { column =>
          seats(row)(column) match {
            case EMPTY_SEAT =>
              if (sociallyDistanced(seats, offsets, row, column, cautiouslyDistanced)) {
                changing = true
                nextSeats = nextSeats.updated(row, nextSeats(row).updated(column, TAKEN_SEAT))
              }
            case TAKEN_SEAT =>
              if (covidRisk(seats, offsets, row, column, cautiouslyDistanced, crowdingTolerance)) {
                changing = true
                nextSeats = nextSeats.updated(row, nextSeats(row).updated(column, EMPTY_SEAT))
              } 
            case FLOOR => //do nothing
          }        
        }
      }
      seats = nextSeats
    }
    
    return seats
  }

  def sociallyDistanced(seats: List[List[Any]], offsets: List[(Int,Int)], row: Int, column: Int, cautiouslyDistanced: Boolean): Boolean = {
    var overallOffsets = if (cautiouslyDistanced) offsets.union(stayClearOfWalkWays(seats, offsets, row, column)) else offsets

    return overallOffsets
      .filter(offset => inBounds(seats, row + offset._1, column + offset._2))
      .forall(offset => seats(row + offset._1)(column + offset._2) == EMPTY_SEAT || seats(row + offset._1)(column + offset._2) == FLOOR)
  }

  def covidRisk(seats: List[List[Any]], offsets: List[(Int,Int)], row: Int, column: Int, cautiouslyDistanced: Boolean, crowdingTolerance: Int): Boolean = {
    var overallOffsets = if (cautiouslyDistanced) offsets.union(stayClearOfWalkWays(seats, offsets, row, column)) else offsets

    return overallOffsets
      .filter(offset => inBounds(seats, row + offset._1, column + offset._2))
      .count(offset => seats(row + offset._1)(column + offset._2) == TAKEN_SEAT) >= crowdingTolerance
  }

  def stayClearOfWalkWays(seats: List[List[Any]], offsets: List[(Int,Int)], row: Int, column: Int): List[(Int,Int)] = {
    var additionalOffsets = ListBuffer[(Int,Int)]()
    offsets
    .filter(offset => inBounds(seats, row + offset._1, column + offset._2))
    .foreach { offset =>
      var mutableOffset = offset
      while (inBounds(seats, row + mutableOffset._1, column + mutableOffset._2) && seats(row + mutableOffset._1)(column + mutableOffset._2) == FLOOR) {
        mutableOffset = (mutableOffset._1 + offset._1, mutableOffset._2 + offset._2)
        additionalOffsets += Tuple2(mutableOffset._1, mutableOffset._2)
      }
    }
    return additionalOffsets.toList
  }

  def inBounds(seats: List[List[Any]], rowOffset: Int, columnOffset: Int): Boolean =
    seats.length > 0 && 
      rowOffset >= 0 && rowOffset < seats.length && 
      columnOffset >= 0 && columnOffset < seats(rowOffset).size
}