/* eslint-disable no-restricted-syntax */
/**
 * Replacement for the Vue 2-based EventBus.
 *
 * @template EventName
 */
class Bus {
  constructor() {
    /**
     * @type {Map<EventName, Array<{ callback: Function, once: boolean }>>}
     */
    this.eventListeners = new Map();
  }

  /**
   * @param {EventName} eventName
   * @param {Function} callback
   * @param {boolean} [once]
   * @private
   */
  registerEventListener(eventName, callback, once = false) {
    if (!this.eventListeners.has(eventName)) {
      this.eventListeners.set(eventName, []);
    }

    const eventListeners = this.eventListeners.get(eventName);
    eventListeners.push({ callback, once });
  }

  /**
   *
   * @param {EventName} eventName
   * @param {Function} callback
   */
  $on(eventName, callback) {
    this.registerEventListener(eventName, callback);
  }

  /**
   *
   * @param {EventName} eventName
   * @param {Function} callback
   */
  $once(eventName, callback) {
    const once = true;
    this.registerEventListener(eventName, callback, once);
  }

  /**
   * Removes all event listeners for the given event name or names.
   *
   * When provided with a callback function, removes only event listeners matching the provided function.
   *
   *
   * @param {EventName | EventName[]} eventNameOrNames
   * @param {Function} [callback]
   */
  $off(eventNameOrNames, callback = undefined) {
    const eventNames = Array.isArray(eventNameOrNames)
      ? eventNameOrNames
      : [eventNameOrNames];

    eventNames.forEach((eventName) => {
      const eventListeners = this.eventListeners.get(eventName);

      if (eventListeners === undefined) {
        return;
      }

      if (typeof callback === 'function') {
        for (let i = eventListeners.length - 1; i >= 0; i -= 1) {
          if (eventListeners[i].callback === callback) {
            eventListeners.splice(i, 1);
          }
        }
      } else {
        this.eventListeners.delete(eventName);
      }
    });
  }

  /**
   *
   * @param {EventName} eventName
   * @param {any} args
   */
  $emit(eventName, ...args) {
    if (!this.eventListeners.has(eventName)) {
      return;
    }

    const eventListeners = this.eventListeners.get(eventName);
    const eventListenerIndexesToDelete = [];
    for (const [
      eventListenerIndex,
      eventListener,
    ] of eventListeners.entries()) {
      eventListener.callback(...args);

      if (eventListener.once) {
        eventListenerIndexesToDelete.push(eventListenerIndex);
      }
    }

    for (let i = eventListenerIndexesToDelete.length - 1; i >= 0; i -= 1) {
      eventListeners.splice(eventListenerIndexesToDelete[i], 1);
    }
  }
}

const EventBus = new Bus();

export default EventBus;
