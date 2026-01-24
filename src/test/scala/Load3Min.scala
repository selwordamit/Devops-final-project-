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
    .pause(300.millis, 900.millis) // 
 
  setUp(
    scn.inject(
      rampConcurrentUsers(1).to(27).during(30.seconds),
      constantConcurrentUsers(27).during(3.minutes) 
    )
  ).protocols(httpProtocol)
   // --- Assertions ---
   .assertions(
     global.responseTime.max.lt(15000),      // Fail if response time is more than 15 seconds
     global.successfulRequests.percent.gt(90) // Fail if less than 90% request succeed
   )
}