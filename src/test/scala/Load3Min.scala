import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class Load3Min extends Simulation {

  val httpProtocol = http
    .baseUrl("http://4.178.56.71:8081")
    .acceptHeader("text/html")
    .userAgentHeader("Mozilla/5.0")

  val scn = scenario("Load Test 3 Minutes")
    .exec(
      http("GET Home")
        .get("/Devops-final-project-/adamliadadiramityuri/")
        .check(status.is(200))
    )
    .pause(300.millis, 900.millis)

  setUp(
    scn.inject(
      rampConcurrentUsers(1).to(30).during(30.seconds),
      constantConcurrentUsers(30).during(3.minutes)
    )
  ).protocols(httpProtocol)
   // --- Assertions ---
   .assertions(
     global.responseTime.max.lt(5000),      // Fail if response time is more than 5 seconds
     global.successfulRequests.percent.gt(95) // Fail if less than 95% request succeed
   )
}