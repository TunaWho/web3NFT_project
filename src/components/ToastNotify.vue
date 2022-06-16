<template>
  <div v-if="Object.keys(notifications).length" class="global-notifications">
    <div class="block-notifications">
      <div
        v-for="(notification, index) of notifications"
        :key="index"
        :ref="index"
        :class="[
          'block-notification',
          notification.show || false ? 'notification-show' : '',
          'block-notification-' + (notification.type || 'success'),
        ]"
        class="block-notification block-notification-success"
      >
        <div class="block-notification-icon" />
        <div class="block-notification-contents">
          <div class="block-notification-content-title">
            {{ notification.title || '' }}
          </div>
          <div
            class="block-notification-content"
            v-html="notification.content || ''"
          />
        </div>
        <div class="block-notification-button">
          <span aria-hidden="true" @click="removeNotification(index)"
            >&times;</span
          >
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue';
import eventBus from '@/events';

const notifications = ref({});
const defaultTimeout = ref(5000);
const maxNotification = ref(4);

function hideNotification(notificationId) {
  if (
    Object.prototype.hasOwnProperty.call(notifications.value, notificationId)
  ) {
    notifications.value[notificationId].show = false;
  }
}

function deleteNotification(notificationId) {
  delete notifications.value[notificationId];
}

function removeNotification(notificationId) {
  hideNotification(notificationId);
  setTimeout(
    () => {
      deleteNotification(notificationId);
    },
    600,
    this
  );
}

function setAutoHiddenNotification(notificationId, timeout) {
  const setTime = parseInt(timeout, 10);
  setTimeout(
    () => {
      removeNotification(notificationId);
    },
    setTime,
    this
  );
}

function showNotification(notificationId) {
  if (
    Object.prototype.hasOwnProperty.call(notifications.value, notificationId)
  ) {
    notifications.value[notificationId].show = true;
  }
}

function setClassShow(notificationId) {
  setTimeout(
    () => {
      showNotification(notificationId);
    },
    10,
    this
  );
}

function initDefaultNotification() {
  Object.keys(notifications.value).forEach((notificationId) => {
    const notification = notifications.value[notificationId];
    const timeout = notification.timeout || defaultTimeout.value;

    setAutoHiddenNotification(notificationId, timeout);
    setClassShow(notificationId);
  });
}

function removeNotificationByMaxSetting() {
  const setMaxNotification = maxNotification.value - 1;
  const notificationKeys = Object.keys(notifications.value);
  const notificationNumber = notificationKeys.length;

  let notificationNumberRemove = notificationNumber - setMaxNotification;
  notificationNumberRemove = parseInt(notificationNumberRemove, 10);

  if (notificationNumberRemove > 0) {
    Object.keys(notificationKeys).forEach((notificationKey) => {
      if (notificationNumberRemove > 0) {
        removeNotification(notificationKeys[notificationKey]);

        notificationNumberRemove -= 1;
      }
    });
  }
}

function appendNotification(notification) {
  removeNotificationByMaxSetting();

  const notificationId = (Math.random() + 1).toString(36).substring(7);
  const timeout = notification.timeout || defaultTimeout.value;
  notifications.value = {
    [notificationId]: notification,
  };

  setAutoHiddenNotification(notificationId, timeout);
  setClassShow(notificationId);
}

onMounted(() => {
  eventBus.$on('toastify', appendNotification);
  initDefaultNotification();
});

onBeforeUnmount(() => {
  eventBus.$off('toastify', appendNotification);
});
</script>

<style lang="scss" src="@/assets/scss/toast.scss"></style>
