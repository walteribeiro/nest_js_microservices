import { NestFactory } from '@nestjs/core';
import { NotificationsServiceModule } from './notifications-service.module';
import { ValidationPipe } from '@nestjs/common';
import { MicroserviceOptions, Transport } from '@nestjs/microservices';

async function bootstrap() {
  const app = await NestFactory.create(NotificationsServiceModule);
  app.useGlobalPipes(new ValidationPipe());
  app.connectMicroservice<MicroserviceOptions>(
    {
      transport: Transport.RMQ,
      options: {
        urls: [process.env.RABBITMQ_URL!],
        noAck: false,
        //queue: 'notifications-service',
      },
    },
    { inheritAppConfig: true },
  );
  await app.startAllMicroservices();
  await app.listen(process.env.PORT ?? 3004);
}
bootstrap();
