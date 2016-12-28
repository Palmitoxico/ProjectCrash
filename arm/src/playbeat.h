/*
 * Play the beat at a specified time
 */

#ifndef PLAYBEAT_H_
#define PLAYBEAT_H_

#include <stdint.h>

void PlayBeatInit();
int32_t MarkBeat(uint32_t TimeAhead);

#endif
