#include "camera.h"

int main(int argc, char* argv[])
{
    ad::camera_interface camera(2000, 1000);

    std::cout << camera.get_camera_sizes().first << ' ' << camera.get_camera_sizes().second << std::endl;

    camera.show_camera("Camera", ad::esc_button, "/home/anton/Projects/technopark/c++/camera/imgs", 1, false);

    return 0;
}