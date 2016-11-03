/*
 * midievents
 * 
 * Read a Midi smf file and extract
 * the notes timestamps
 */
#include <smf.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct
{
	double *time;
	int length;
	int allocated;
} EventsTimeVector;

EventsTimeVector *NewTimeVector()
{
	EventsTimeVector *t;

	t = malloc(sizeof(EventsTimeVector));
	t->length = 0;
	t->allocated = 16;
	t->time = malloc(sizeof(double) * 16);
}

int DeleteTimeVector(EventsTimeVector *t)
{
	free(t->time);
	free(t);
	return 0;
}

int AppendToTimeVector(EventsTimeVector *t, double time)
{
	if (t->length >= t->allocated)
	{
		t->time = realloc(t->time, (t->length + 16) * sizeof(double));
		t->allocated = (t->length + 16);
	}
	t->time[t->length] = time;
	t->length += 1;
	return 0;
}

int main(int argc, char *argv[])
{
	smf_t *smf;
	smf_event_t *event;
	smf_track_t *track;
	EventsTimeVector *TimeStamps = NewTimeVector();
	int i;
	double LastTime = 0, DeltaTime = 0.01;


	if (argc < 2)
	{
		printf("Usage: Filename [DeltaTime]\n");
		return -1;
	}
	else if (argc == 2)
	{
		
	}
	else if (argc == 3)
	{
		DeltaTime = atof(argv[2]);
		if (DeltaTime < 0.0)
		{
			printf("The DeltaTime must be positive!\n");
			return -1;
		}
	}
	
	smf = smf_load(argv[1]);

	if (smf == NULL)
	{
		printf("File error!\n");
		return -1;
	}
	
	while ((event = smf_get_next_event(smf)) != NULL)
	{
		/*
		 * Ignore metadata events
		 */
		if (!smf_event_is_metadata(event))
		{
			/*
			 * Only log "Note On" events
			 */
			if (event->midi_buffer[0] == 0x90)
			{
				/*
				 * Decides if this note is sufficiently
				 * far in time from the last one
				 */
				if ((event->time_seconds - LastTime) > DeltaTime)
				{
					AppendToTimeVector(TimeStamps, event->time_seconds);
					LastTime = event->time_seconds;
				}
			}
		}
	}

	/*
	 * Print all timestamps
	 */
	for (i = 0; i < TimeStamps->length; i++)
	{
		printf("%.0f\n", TimeStamps->time[i]*1000);
	}
	
	DeleteTimeVector(TimeStamps);
	smf_delete(smf);
    return 0;
}
