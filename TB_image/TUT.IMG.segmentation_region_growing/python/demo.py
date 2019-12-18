import queue
from scipy import misc
import matplotlib.pyplot as plt
import numpy as np
import imageio


def predicate(image, i, j, seed, visited):
    """
    Predicate
    Must ensures that integer values are manipulated
    """
    f = int(image[i, j])
    g = int(image[seed[0], seed[1]])
    return abs(f - g) < 20


def predicate2(image, i, j, seed, visited):
    """
    Predicate
    Must ensures that integer values are manipulated
    """
    f = int(image[i, j])
    m = np.mean(image[visited == 1])
    return abs(f - m) < 20


def predicate3(image, i, j, seed, visited):
    """
    Predicate
    Must ensures that integer values are manipulated
    """
    f = int(image[i, j])
    m = np.mean(image[visited == 1])
    s = np.std(image[visited == 1])
    return abs(f - m) < 20 * (1-s/m)


def onpick(event):
    """
    this functions gets the event 'click', and starts the region growing algorithm
    Notice that img is a global variable
    """
    print("x, y: ", event.xdata, event.ydata)
    # original pixel
    seed = np.array([int(event.ydata), int(event.xdata)])
    q = queue.Queue()

    myfunctions = [predicate, predicate2, predicate3]

    for index, f in enumerate(myfunctions):

        # initializes the queue
        q.put(seed)

        # Visited matrix : result of segmentation
        # this matrix will contain 1 if in the region, -1 if visited but not in the
        # region, 0 if not visited
        visited = np.zeros(img.shape)
        # --------------------------------------------------------------------------
        # Start of algorithm
        visited[seed[0], seed[1]] = 1

        while not q.empty():
            p = q.get()

            for i in range(max(0, p[0] - 1), min(img.shape[0], p[0] + 2)):
                for j in range(max(0, p[1] - 1), min(img.shape[1], p[1] + 2)):
                    if not visited[i, j]:
                        if f(img, i, j, seed, visited):
                            visited[i, j] = 1
                            q.put(np.array([i, j]))
                        else:
                            visited[i, j] = -1

        # end of the algorithm: the visited matrix contains the segmentation result
        # --------------------------------------------------------------------------

        # display results
        ax = fig.add_subplot(142+index)
        ax.imshow(visited == 1)

        imageio.imsave(f.__name__ + '_seg.python.png',
                       (visited == 1).astype('int'))

        print("computed for ", f.__name__)
    fig.canvas.draw()
    plt.show()
    return


# start by displaying a figure, ask for mouse input (click)
fig = plt.figure()
ax = fig.add_subplot(141)
ax.set_title('Click on a point')
# load image
img = misc.ascent()
imageio.imsave('ascent.png', img)
ax.imshow(img, picker=True, cmap=plt.gray())

# connect click on image to onpick function
fig.canvas.mpl_connect('button_press_event', onpick)
plt.show()
