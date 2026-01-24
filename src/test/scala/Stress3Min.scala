import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class Stress3Min extends Simulation {

  val httpProtocol = http
    .baseUrl("http://4.178.56.71:8081")
    .acceptHeader("text/html")
    .userAgentHeader("Mozilla/5.0")

  val scn = scenario("Stress Test 3 Minutes")
    .exec(
      http("GET Home")
        .get("/Devops-final-project-/adamliadadiramityuri/")
        .check(status.is(200))
    )
    .pause(200.millis, 800.millis)

  setUp(
    scn.inject(
      rampConcurrentUsers(1).to(70).during(3.minutes)
    )
  ).protocols(httpProtocol)
   // --- Assertions Stress ---
   .assertions(
     global.successfulRequests.percent.gt(90), // Fail if less than 90% requests succeed
     global.responseTime.mean.lt(20000)         // Fail if response time is more than 20 seconds
   )
}