#include <Sensor.h>
#include <BottomLidar.h>
#include <MobileLidar.h>
#include <TopLidar.h>
#include <Dir.h>
#include <unity.h>
#include <Vector.h>
#define MAX_SIZE 100

Dir dir;

void test_function_capture_BottomLidar(void)
{
  BottomLidar lidar;
}

void test_function_detection_BottomLidar(void)
{
  BottomLidar lidar;
  Pos obstacle[MAX_SIZE];
  Vector<Pos> obstacles(obstacle);
  Pos detectable[MAX_SIZE];
  Vector<Pos> detectables(detectable);
  obstacles = lidar.detection(detectables);
}

int main(int argc, char* argv[])
{
  UNITY_BEGIN();
  RUN_TEST(test_function_capture_BottomLidar);
  RUN_TEST(test_function_detection_BottomLidar);
  UNITY_END();
}
