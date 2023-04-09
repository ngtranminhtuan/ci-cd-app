from django.test import TestCase
from django.contrib.auth import get_user_model


class ModelTests(TestCase):

    def test_create_user_with_email_successfull(self):
        """Test create new user with an email is successfull"""
        username = "testuser",
        email = 'test@9cv9.com'
        password = 'testpass123'

        user = get_user_model().objects.create_user(
            username=username,
            email=email,
            password=password,
        )

        self.assertEqual(user.email, email)
        self.assertTrue(user.check_password(password))
