//
// Created by anton on 07.11.17.
//

#ifndef CAMERA_CAMERA_H
#define CAMERA_CAMERA_H

#include <cv.h>
#include <highgui.h>
#include <iostream>
#include <string>


namespace ad {

static const int esc_button = 27;

    class camera_interface {

    public:

        explicit camera_interface(size_t _width = 640, size_t _height = 480) : width(_width), height(_height) {

            capture = cvCreateCameraCapture(CV_CAP_ANY);
            cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_WIDTH, width);
            cvSetCaptureProperty(capture, CV_CAP_PROP_FRAME_HEIGHT, height);

            assert(capture);
        }

        const std::pair<size_t, size_t> get_camera_sizes() {
            return std::pair<size_t, size_t>(width, height);
        }

        const void show_camera(std::string window_name, int exit_symbol, std::string folder_name, int delay = 33, bool save_flag = false) {

            IplImage* frame=0;

            cvNamedWindow(window_name.data(), CV_WINDOW_AUTOSIZE);

            size_t counter = 0;
            std::string filename = "Image";

            while(true){

                frame = cvQueryFrame(capture);

                char c = cvWaitKey(delay); // получение кнопки

                if (c == exit_symbol) { // нажата кнопка выхода
                    break;
                }

                if(counter % delay == 0) {
                    cvShowImage(window_name.data(), frame);
                    if(save_flag)
                        cvSaveImage((folder_name + "/" + filename + std::to_string(counter / delay) + ".jpg").data(), frame);
                }

                if(counter >= 1000000) { counter = 0;}

                ++counter;
            }

            cvDestroyWindow(window_name.data());
        }


        ~camera_interface() {
            cvReleaseCapture(&capture);
        }

    private:

        size_t width;
        size_t height;
        CvCapture* capture;
    };


}


#endif //CAMERA_CAMERA_H
